<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucReportLayout.ascx.cs" Inherits="QuickStartAdmin.Users.usercontrol.ucReportLayout" %>
<div class="modal-dialog modal-sm divpopup" id="divTableLayout" style="width: 400px; display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h4 class="modal-title">Set Table Layout</h4>
            <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
        </div>
        <div class="clearfix"></div>
        <div style="height: 400px; overflow: auto;">
            <table class="table table-striped table-bordered table-quicklist" style="width: 100%" id="tblTableLayout">
                <thead>
                    <tr>
                        <th style="width: 30px;"></th>
                        <th>Column</th>
                        <th>Display Name</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
        <div class="clearfix"></div>
        <div class="divpopbutton">
            <div style="float: left; display: none">

                <label class="checkbox">
                    Save For All Users
                                                                <input id="chkForAllUsersLayout" type="checkbox" />
                    <span class="checkmark"></span>
                </label>
            </div>
            <div class="text-right">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Save" id="btnSaveLayout" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Reset Layout" id="btnResetLayout" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" onclick="closediv();" />
            </div>

        </div>
    </div>
</div>


<div class="modal-dialog modal-sm divpopup" id="divRefreshLayout" style="width: 400px; display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h4 class="modal-title">Layout reset successfully</h4>
            <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
        </div>
        <div class="clearfix"></div>
        <div style="height: 100px; overflow: auto; text-align: center;">
            <span style="font-weight:bold;">Please refresh your page to take effect</span>
            <br />
            <br />
            <input type="button" class="btn btn-success waves-effect waves-light" value="Refersh" onclick="location.reload();" />
            <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" />
        </div>
        <div class="clearfix"></div>

    </div>
</div>
