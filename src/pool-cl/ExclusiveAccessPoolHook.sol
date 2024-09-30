// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {CLBaseHook} from "./CLBaseHook.sol";

import {ICLPoolManager} from "pancake-v4-core/src/pool-cl/interfaces/ICLPoolManager.sol";

import {BalanceDelta} from "pancake-v4-core/src/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "pancake-v4-core/src/types/BeforeSwapDelta.sol";
import {LPFeeLibrary} from "pancake-v4-core/src/libraries/LPFeeLibrary.sol";
import {PoolId, PoolIdLibrary} from "pancake-v4-core/src/types/PoolId.sol";
import {PoolKey} from "pancake-v4-core/src/types/PoolKey.sol";

interface IExclusiveAccessCheck {
    function verify(address user) external view returns (bool);
}

contract ExclusiveAccessHook is CLBaseHook {
    using PoolIdLibrary for PoolKey;

    IExclusiveAccessCheck public accessChecker;

    error NotAuthorized();

    constructor(
        ICLPoolManager _poolManager,
        address _accessChecker
    ) CLBaseHook(_poolManager) {
        accessChecker = IExclusiveAccessCheck(_accessChecker);
    }

    function setAccessChecker(address _accessChecker) external poolManagerOnly {
        accessChecker = IExclusiveAccessCheck(_accessChecker);
    }

    function getHooksRegistrationBitmap()
        external
        pure
        override
        returns (uint16)
    {
        return
            _hooksRegistrationBitmapFrom(
                Permissions({
                    beforeInitialize: false,
                    afterInitialize: false,
                    beforeAddLiquidity: false,
                    afterAddLiquidity: false,
                    beforeRemoveLiquidity: false,
                    afterRemoveLiquidity: false,
                    beforeSwap: true,
                    afterSwap: false,
                    beforeDonate: false,
                    afterDonate: false,
                    beforeSwapReturnsDelta: false,
                    afterSwapReturnsDelta: false,
                    afterAddLiquidityReturnsDelta: false,
                    afterRemoveLiquidityReturnsDelta: false
                })
            );
    }

    function beforeSwap(
        address sender,
        PoolKey calldata,
        ICLPoolManager.SwapParams calldata,
        bytes calldata
    )
        external
        override
        poolManagerOnly
        returns (bytes4, BeforeSwapDelta, uint24)
    {
        if (!accessChecker.verify(sender)) {
            revert NotAuthorized();
        }
        return (this.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }
}
