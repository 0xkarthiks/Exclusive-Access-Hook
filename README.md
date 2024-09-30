# Exclusive Access Hook

### Overview

The Exclusive Access Hook is a custom access control hook built for PancakeSwap V4. It utilizes a modular design of hooks to enforce specific access control rules when interacting with the liquidity pools. This hook allows developers and pool managers to set dynamic criteria that must be fulfilled for a user to perform specific actions within the liquidity pool, such as swapping tokens, holding a particular NFT and more.

The access criteria are determined by the IExclusiveAccessCheck interface, which can be extended to support various eligibility requirements. By utilizing this architecture, PancakeSwap can support customizable pool access control, providing flexibility for both pool managers and end-users.

### About

The Exclusive Access Hook is built on top of the PancakeSwap V4's CLBaseHook and integrates with the ICLPoolManager. It allows for an easy setup of custom access criteria, such as holding specific tokens, owning NFTs, or fulfilling governance conditions. The hook checks if a user is eligible for certain operations (here, swaps) using an external contract implementing the IExclusiveAccessCheck interface. The Exclusive Access Hook enforces exclusive access to swap or interact with the pool by verifying conditions dynamically defined in the external access checker. This ensures that only authorized users can interact with the liquidity pools, providing a unique level of customization.

### What It Aims to Achieve

- Exclusive pool access: Enable pool managers to restrict swap or other operations within a liquidity pool to specific users

- Modular & Extensible: Provide a mechanism that allows the dynamic specification of access criteria by using different external contracts implementing the IExclusiveAccessCheck interface

- Security & Flexibility: Enhance security by making sure only authorized users, based on different on-chain actions, can interact with the pools

## Key Features

- Dynamic access control: The access control is defined by an external contract (accessChecker) that implements the IExclusiveAccessCheck interface

- Flexible implementation: Developers can implement any logic within the verify function, allowing for different types of access control criteria, such as:

  - Holding specific ERC20 tokens
  - Owning NFTs from a specific collection
  - Being whitelisted or meeting a time based condition

- Upgradeable criteria: The accessChecker can be updated by the pool manager, allowing for changing access rules even after the pool is live

## Contract Walkthrough

### ExclusiveAccessHook.sol

- Constructor:
  Takes an ICLPoolManager and an accessChecker address to initialize the hook.
  accessChecker should be the address of a contract implementing the IExclusiveAccessCheck interface

- Access checker update: setAccessChecker(address \_accessChecker) function allows the pool manager to update the criteria contract

- Access verification:
  - In the beforeSwap hook, before a swap is allowed, the hook calls accessChecker.verify(sender) to check if the user is authorized
  - If verification fails, the transaction reverts with an error

## Examples of IExclusiveAccessCheck Implementations

The `IExclusiveAccessCheck` interface is the backbone for defining the criteria used to verify access to the liquidity pools. Below are some examples found in the `src/pool-cl/examples` directory

1. `ERC20AccessCheck.sol`
   Users must hold a minimum amount of a specific ERC20 token to qualify for exclusive access

2. `ERC721AccessCheck.sol`
   Users must own at least one NFT from a specific ERC721 collection to qualify for exclusive access

3. `TimeBasedAccessCheck.sol`
   Access is allowed only after a specific time has passed, useful for scheduled releases or exclusive access based on timing

4. `WhitelistAccessCheck.sol`
   Users must be added to a whitelist to gain access to the pool. The whitelist can be managed dynamically

5. `LockedNFTAccessCheck.sol`
   Users must lock a specific NFT in the contract for a predefined period to qualify for exclusive access

> These are some basic examples, and users/developers can create any complex criteria possible - both on-chain and off-chain

## Future Scope

The Exclusive Access Hook has the potential for significant enhancements and cross-chain capabilities. Here are some future directions

1. More diverse criteria

- Additional implementations of the `IExclusiveAccessCheck` interface could include checks based on:
  - Participation in governance (EG: Snapshot or onchain proposals)
  - Engagement metrics (EG: frequent usage of DeFi protocols)

2. Cross-chain integration

   - Integrate LayerZero or Wormhole to enable cross-chain eligibility checks
   - This would allow users on different blockchains to qualify for exclusive access based on activity or asset holdings across chains, increasing the reach and utility of the PancakeSwap pools

3. Multi-Criteria Access Control

- Implement a combination of multiple criteria (AND/OR logic) to have more sophisticated rules. For example:
  - Access granted if a user owns a specific NFT AND has a reputation score above a certain threshold
  -

### Usage Examples

1. Setting Up a Pool with Exclusive Access:

- Deploy a pool using PancakeSwap V4
- Deploy an appropriate `IExclusiveAccessCheck` contract, such as `ERC20AccessCheck.sol`, to define your desired access control logic.
- Use the `ExclusiveAccessHook` to ensure only users meeting the criteria defined in ERC20AccessCheck are allowed to interact with the pool.

2. Updating Access Rules:

- If the pool manager decides to change the access criteria, they can call the setAccessChecker function on `ExclusiveAccessHook` to update the access control logic to a new contract.
