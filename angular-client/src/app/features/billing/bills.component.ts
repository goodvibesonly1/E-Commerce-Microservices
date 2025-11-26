import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { BillingService } from '../../core/services/billing.service';
import { Bill } from '../../shared/models/bill.model';

@Component({
    selector: 'app-bills',
    standalone: true,
    imports: [CommonModule, MatTableModule, MatCardModule, MatIconModule, MatButtonModule],
    template: `
    <div class="container">
      <mat-card>
        <mat-card-header>
          <mat-card-title>Bills</mat-card-title>
        </mat-card-header>
        <mat-card-content>
          <table mat-table [dataSource]="bills" class="mat-elevation-z8">
            <ng-container matColumnDef="id">
              <th mat-header-cell *matHeaderCellDef> ID </th>
              <td mat-cell *matCellDef="let element"> {{element.id}} </td>
            </ng-container>

            <ng-container matColumnDef="date">
              <th mat-header-cell *matHeaderCellDef> Date </th>
              <td mat-cell *matCellDef="let element"> {{element.billingDate | date}} </td>
            </ng-container>

            <ng-container matColumnDef="customer">
              <th mat-header-cell *matHeaderCellDef> Customer </th>
              <td mat-cell *matCellDef="let element"> {{element.customer?.name || element.customerID}} </td>
            </ng-container>

            <ng-container matColumnDef="actions">
              <th mat-header-cell *matHeaderCellDef> Actions </th>
              <td mat-cell *matCellDef="let element">
                <button mat-icon-button color="primary">
                  <mat-icon>visibility</mat-icon>
                </button>
              </td>
            </ng-container>

            <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
            <tr mat-row *matRowDef="let row; columns: displayedColumns;"></tr>
          </table>
        </mat-card-content>
      </mat-card>
    </div>
  `,
    styles: [`
    .container { padding: 20px; }
    table { width: 100%; margin-top: 20px; }
  `]
})
export class BillsComponent implements OnInit {
    bills: Bill[] = [];
    displayedColumns: string[] = ['id', 'date', 'customer', 'actions'];

    constructor(private billingService: BillingService) { }

    ngOnInit(): void {
        this.billingService.getBills().subscribe({
            next: (data) => this.bills = data,
            error: (err) => console.error('Error fetching bills', err)
        });
    }
}
