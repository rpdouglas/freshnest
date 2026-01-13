import React from 'react';
import { Page, Text, View, Document, StyleSheet } from '@react-pdf/renderer';
import { format } from 'date-fns';

// Define styles
const styles = StyleSheet.create({
  page: {
    padding: 40,
    fontSize: 12,
    fontFamily: 'Helvetica',
    color: '#333'
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 40,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
    paddingBottom: 20
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#0ea5e9' // Brand Blue
  },
  section: {
    marginBottom: 20
  },
  label: {
    fontSize: 10,
    color: '#666',
    marginBottom: 4,
    textTransform: 'uppercase'
  },
  value: {
    fontSize: 12,
    marginBottom: 8
  },
  table: {
    marginTop: 40,
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderBottomColor: '#333',
    paddingBottom: 8
  },
  total: {
    marginTop: 20,
    textAlign: 'right',
    fontSize: 18,
    fontWeight: 'bold'
  },
  footer: {
    position: 'absolute',
    bottom: 30,
    left: 40,
    right: 40,
    fontSize: 10,
    textAlign: 'center',
    color: '#999'
  }
});

const InvoiceDocument = ({ job, client }) => {
  const invoiceNum = job.invoiceNumber || 'DRAFT';
  const date = job.invoicedAt ? format(job.invoicedAt, 'MMM d, yyyy') : format(new Date(), 'MMM d, yyyy');

  return (
    <Document>
      <Page size="A4" style={styles.page}>
        
        {/* HEADER */}
        <View style={styles.header}>
          <View>
            <Text style={styles.title}>INVOICE</Text>
            <Text style={styles.label}>#{invoiceNum}</Text>
          </View>
          <View style={{ alignItems: 'flex-end' }}>
            <Text style={{ fontSize: 16, fontWeight: 'bold' }}>Fresh Nest</Text>
            <Text style={styles.label}>Date: {date}</Text>
          </View>
        </View>

        {/* BILL TO */}
        <View style={styles.section}>
          <Text style={styles.label}>Bill To:</Text>
          <Text style={{ fontSize: 14, fontWeight: 'bold' }}>{client.name}</Text>
          <Text style={styles.value}>{client.email}</Text>
          <Text style={styles.value}>{client.address}</Text>
        </View>

        {/* DETAILS */}
        <View style={styles.table}>
          <Text style={{ width: '60%' }}>Description</Text>
          <Text style={{ width: '20%', textAlign: 'right' }}>Date</Text>
          <Text style={{ width: '20%', textAlign: 'right' }}>Amount</Text>
        </View>

        <View style={{ flexDirection: 'row', paddingTop: 10 }}>
          <Text style={{ width: '60%' }}>
            {job.serviceType.charAt(0).toUpperCase() + job.serviceType.slice(1)} Cleaning Service
          </Text>
          <Text style={{ width: '20%', textAlign: 'right' }}>
            {job.scheduledDate ? format(job.scheduledDate, 'MMM d') : ''}
          </Text>
          <Text style={{ width: '20%', textAlign: 'right' }}>
            ${job.price?.toFixed(2)}
          </Text>
        </View>

        {/* TOTAL */}
        <Text style={styles.total}>
          Total Due: ${job.price?.toFixed(2)}
        </Text>

        {/* FOOTER */}
        <Text style={styles.footer}>
          Thank you for choosing Fresh Nest! Please pay within 30 days.
        </Text>
      </Page>
    </Document>
  );
};

export default InvoiceDocument;
