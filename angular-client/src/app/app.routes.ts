import { Routes } from '@angular/router';
import { CustomersComponent } from './features/customers/customers.component';
import { ProductsComponent } from './features/products/products.component';
import { BillsComponent } from './features/billing/bills.component';

export const routes: Routes = [
    { path: 'customers', component: CustomersComponent },
    { path: 'products', component: ProductsComponent },
    { path: 'bills', component: BillsComponent },
    { path: '', redirectTo: '/customers', pathMatch: 'full' }
];
