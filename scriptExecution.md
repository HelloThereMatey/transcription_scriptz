To set the execution policy so that a new PowerShell script can be executed in a non-admin window, follow these steps:

### Setting Execution Policy for PowerShell Scripts

PowerShell's execution policy determines which scripts can be run and under what conditions. To allow the execution of scripts without requiring administrative privileges, you can set the execution policy to `RemoteSigned` or `Unrestricted` for the current user.

#### Steps to Set Execution Policy:

1. **Open PowerShell**:
   - Press `Win + X` and select **Windows PowerShell** or **Windows PowerShell (Admin)** from the menu.

2. **Check Current Execution Policy**:
   - Run the following command to see the current execution policy:

     ```powershell
     Get-ExecutionPolicy -List
     ```

3. **Set Execution Policy for Current User**:
   - To set the execution policy to `RemoteSigned` (recommended for security), run:
  
     ```powershell
     Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
     ```

   - Alternatively, to set the execution policy to `Unrestricted` (less secure), run:
     ```powershell
     Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
     ```

4. **Confirm the Change**:
   - You may be prompted to confirm the change. Type `Y` and press `Enter` to confirm.

5. **Verify the Change**:
   - Run the following command again to verify that the execution policy has been updated:
     ```powershell
     Get-ExecutionPolicy -List
     ```

#### Example Commands:

```powershell
# Open PowerShell and check current execution policy
Get-ExecutionPolicy -List

# Set execution policy to RemoteSigned for the current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Confirm the change if prompted
# Type 'Y' and press 'Enter'

# Verify the change
Get-ExecutionPolicy -List
```

### Important Notes:

- **RemoteSigned**: Requires that all scripts and configuration files downloaded from the internet be signed by a trusted publisher. This is a good balance between security and usability.
- **Unrestricted**: Allows all scripts to run. This is less secure and should be used with caution.
- **Scope**: Setting the scope to `CurrentUser` ensures that the change only affects the current user and does not require administrative privileges.

By following these steps, you can configure PowerShell to allow the execution of scripts without needing to run PowerShell as an administrator.
