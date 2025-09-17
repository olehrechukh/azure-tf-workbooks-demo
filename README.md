# Azure Workbooks with Terraform

This repository contains the code for the article: [Azure Workbooks as Code with Terraform](https://olehrechukh.github.io/personal-blog/blog/azure-workbooks/).

This repository contains a Terraform setup for managing Azure Workbooks, following the Infrastructure as Code (IaC) practice. This approach allows for version control, collaboration, and automation of Azure Workbooks.

## Workflow

The core idea is to use Terraform to manage the lifecycle of the workbook, while using the Azure Portal's rich user interface to design the content of the workbook.

1.  **Create from Scratch with Terraform**: The workbook is initially defined as a Terraform resource (`azurerm_application_insights_workbook` in `main.tf`) which points to a minimal `workbook.json` file. This establishes the workbook as a code-managed asset.
2.  **Populate with Content**: Use the Azure portal's rich UI to add and design charts, tables, and other visualizations within the newly created workbook.
3.  **Capture Content as Code**: After designing the content, use the "Advanced Editor" (`</>`) in the Azure portal to view and copy the workbook's complete JSON definition.
4.  **Update Terraform Configuration**:
    *   Paste the exported JSON into your `workbook.json` file.
    *   Parameterize dynamic values (like resource IDs) in the JSON file using variables (e.g., `${storageAccountId}`).
    *   Update the Terraform resource to use the `templatefile` function. This function injects dynamic values from your Terraform configuration into the `workbook.json` template before applying it.
5.  **Apply and Iterate**: Run `terraform apply` to update the workbook with the new content. This entire process can be repeated as monitoring needs evolve, with each change being committed to version control.

## Best Practices

*   **Commit After Each Iteration**: Save changes to your Git repository after each design-export-update cycle to maintain a clear history.
*   **Separate Concerns**: Keep the workbook's JSON definition in separate files from the main Terraform (`.tf`) logic.
*   **Embrace the Full Loop**: Avoid making manual changes in the portal without capturing them back into your Terraform configuration to ensure the code remains the single source of truth.
