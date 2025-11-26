import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { CustomerService } from '../../core/services/customer.service';
import { Customer } from '../../shared/models/customer.model';

@Component({
    selector: 'app-customers',
    standalone: true,
    imports: [CommonModule, MatTableModule, MatCardModule, MatIconModule, MatButtonModule],
    template: `
    <div class="container">
      <mat-card>
        <mat-card-header>
          <mat-card-title>Customers</mat-card-title>
        </mat-card-header>
        <mat-card-content>
          <table mat-table [dataSource]="customers" class="mat-elevation-z8">
            <ng-container matColumnDef="id">
              <th mat-header-cell *matHeaderCellDef> ID </th>
              <td mat-cell *matCellDef="let element"> {{element.id}} </td>
            </ng-container>

            <ng-container matColumnDef="name">
              <th mat-header-cell *matHeaderCellDef> Name </th>
              <td mat-cell *matCellDef="let element"> {{element.name}} </td>
            </ng-container>

            <ng-container matColumnDef="email">
              <th mat-header-cell *matHeaderCellDef> Email </th>
              <td mat-cell *matCellDef="let element"> {{element.email}} </td>
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
export class CustomersComponent implements OnInit {
    customers: Customer[] = [];
    displayedColumns: string[] = ['id', 'name', 'email'];

    constructor(private customerService: CustomerService) { }

    ngOnInit(): void {
        this.customerService.getCustomers().subscribe({
            next: (data) => this.customers = data,
            error: (err) => console.error('Error fetching customers', err)
        });
    }
}
