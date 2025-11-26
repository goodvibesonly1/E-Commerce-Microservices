import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { Bill } from '../../shared/models/bill.model';

@Injectable({
    providedIn: 'root'
})
export class BillingService {
    private apiUrl = `${environment.apiGatewayUrl}/BILLING-SERVICE/bills`;

    constructor(private http: HttpClient) { }

    getBill(id: number): Observable<Bill> {
        return this.http.get<Bill>(`${this.apiUrl}/${id}`);
    }

    getBills(): Observable<Bill[]> {
        return this.http.get<Bill[]>(this.apiUrl);
    }
}
