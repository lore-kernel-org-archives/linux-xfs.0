Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NALvuC077524 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 05:21:57 -0500
Received: from seldrel01.sonyericsson.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A78DB1C3AEFA
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 03:21:55 -0700 (PDT)
Received: from seldrel01.sonyericsson.com (seldrel01.sonyericsson.com
	[212.209.106.2]) by cuda.sgi.com with ESMTP id GZGEnxCDV0lkRo07
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 03:21:55 -0700 (PDT)
From: "Assarsson, Emil" <Emil.Assarsson@sonyericsson.com>
Date: Fri, 23 Sep 2011 12:21:54 +0200
Subject: Re: silent corruption after kernel panic?
Message-ID: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA722B51@seldmbx01.corpusers.net>
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA722B40@seldmbx01.corpusers.net>
	<20110919142729.GA20750@infradead.org>
In-Reply-To: <20110919142729.GA20750@infradead.org>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "hch@infradead.org" <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

bcOlbiAyMDExLTA5LTE5IGtsb2NrYW4gMTA6MjcgLTA0MDAgc2tyZXYgQ2hyaXN0b3BoIEhlbGx3
aWc6Cj4gT24gTW9uLCBTZXAgMTksIDIwMTEgYXQgMDI6Mjg6MjNQTSArMDIwMCwgQXNzYXJzc29u
LCBFbWlsIHdyb3RlOgo+ID4gSGksCj4gPiAKPiA+IFdlIGFyZSBydW5uaW5nIGEgMjBUQiBYRlMg
ZmlsZXN5c3RlbSBvbiB0b3Agb2YgTFZNMiBhbmQgU0FOIHN0b3JhZ2UgKEhQCj4gPiBPcGVuLVYp
IHdpdGggbXVsdGlwYXRoZC4gVWJ1bnR1IEx1Y2lkLiBUaGUgZGlzayB3cml0ZSBjYWNoZSBpcyBl
bmFibGVkCj4gPiBhbmQgd2UgdXNlIG1vdW50IG9wdGlvbnMgcncuCj4gCj4gCj4gPiBTZXAgMTYg
MDY6NDA6MzQgc2VsZGxueDAzNCBrZXJuZWw6IFs1NDYwNy45NzcyNjFdIFhGUyBpbnRlcm5hbCBl
cnJvcgo+ID4gWEZTX1dBTlRfQ09SUlVQVEVEX1JFVFVSTiBhdCBsaW5lIDM4MSBvZgo+ID4gZmls
ZSAvYnVpbGQvYnVpbGRkL2xpbnV4LTIuNi4zMi9mcy94ZnMveGZzX2FsbG9jLmMuICBDYWxsZXIK
PiA+IDB4ZmZmZmZmZmZhMDFlZWQzNgo+ID4gU2VwIDE2IDA2OjQwOjM0IHNlbGRsbngwMzQga2Vy
bmVsOiBbNTQ2MDcuOTk2Njc2XSAgWzxmZmZmZmZmZmEwMjE1MzgzPl0KPiA+IHhmc19lcnJvcl9y
ZXBvcnQrMHg0My8weDUwIFt4ZnNdCj4gPiBTZXAgMTYgMDY6NDA6MzQgc2VsZGxueDAzNCBrZXJu
ZWw6IFs1NDYwNy45OTY2ODldCj4gCj4gVGhpcyAoY29ycnVwdGVkIGFsbG9jYXRpb24gYnRyZWVz
KSBpcyBhIHR5cGljYWwgaW5kaWNhdGlvbiBvZiBtaXNzaW5nCj4gY2FjaGUgZmx1c2hlcy4KPiAK
PiBHaXZlbiB0aGF0IGJlZm9yZSB+Mi42LjM1IExWTS9kZXZpY2UgbWFwcGVyIHdhcyBub3QgYWJs
ZSB0byBwYXNzIHRocm91Z2gKPiBjYWNoZSBmbHVzaCByZXF1ZXN0cyB0aGF0IGlzIHlvdXIgbW9z
dCBsaWtlbHkgY3VscHJpdC4gIEEgcmVwYWlyIHdpbGwKPiByZWJ1aWxkIHRoZSBmcmVlc3BhY2Ug
YnRyZWVzLCBhbmQgbWFrZSBzdXJlIHRvIGtlZXAgdGhlIHdyaXRlIGNhY2hlcwo+IGRvd24gdGhl
IHdob2xlIHN0YWNrIGRpc2FibGVkLgoKVGhhbmtzIGZvciB5b3UgaGVscCBDaHJpc3RvcGguIEkg
Z3Vlc3MgeW91IGFyZSByaWdodC4gU29tZSBvZiBvdXIgc3lzdGVtCmhhZCB3cml0ZSBjYWNoZSBl
bmFibGVkIGFuZCB1c2VkIERldmljZSBNYXBwZXIuIFdlIGhhdmUgZGlzYWJsZWQgdGhlCmNhY2hl
LgoKV2UgZ290IHNvbWUgbmV3LCBwb3NzaWJseSByZWxhdGVkLCBwcm9ibGVtcyBhbmQgd2FzIGZv
cmNlZCB0byBjbGVhciB0aGUKbG9nLiBXZSBkZWNpZGVkIHRvIG1vdmUgdGhlIGRhdGEgdG8gYSBm
cmVzaCBmaWxlIHN5c3RlbS4gV2Ugd2lsbCB1c2UKeGZzX2R1bXAvcmVzdG9yZS4KCi0tCkVtaWwg
QXNzYXJzc29uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWls
bWFuL2xpc3RpbmZvL3hmcwo=
