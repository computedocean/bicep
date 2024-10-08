// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
import { ManagementGroupInfo, ManagementGroupsAPI } from "@azure/arm-managementgroups";
import { DefaultAzureCredential } from "@azure/identity";
import { SubscriptionTreeItemBase, uiUtils } from "@microsoft/vscode-azext-azureutils";
import { AzExtTreeItem } from "@microsoft/vscode-azext-utils";
import { localize } from "../utils/localize";
import { GenericAzExtTreeItem } from "./GenericAzExtTreeItem";

// Represents tree item used to display management groups
export class ManagementGroupTreeItem extends SubscriptionTreeItemBase {
  public readonly childTypeLabel: string = localize("managementGroup", "Management Group");

  private _nextLink: string | undefined;

  public hasMoreChildrenImpl(): boolean {
    return !!this._nextLink;
  }

  // Loads management groups
  public async loadMoreChildrenImpl(): Promise<AzExtTreeItem[]> {
    const managementGroupsAPI = new ManagementGroupsAPI(new DefaultAzureCredential());

    let managementGroupInfos: ManagementGroupInfo[] = [];

    try {
      managementGroupInfos = await uiUtils.listAllIterator(managementGroupsAPI.managementGroups.list());
    } catch {
      throw new Error(
        "You do not have access to any management group. Please create one in the Azure portal and try to deploy again",
      );
    }

    return await this.createTreeItemsWithErrorHandling(
      managementGroupInfos,
      "invalidManagementGroup",
      (mg) => new GenericAzExtTreeItem(this, mg.id, mg.name),
      (mg) => mg.name,
    );
  }
}
