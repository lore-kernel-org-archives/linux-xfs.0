Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBOCwdrY075968 for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 06:58:39 -0600
Received: from mail-bw0-f217.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53DE11C14212
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 04:59:22 -0800 (PST)
Received: from mail-bw0-f217.google.com (mail-bw0-f217.google.com
	[209.85.218.217]) by cuda.sgi.com with ESMTP id
	RlrN58lvfxRIF2Uk for <xfs@oss.sgi.com>;
	Thu, 24 Dec 2009 04:59:22 -0800 (PST)
Received: by bwz9 with SMTP id 9so5120167bwz.12
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 04:59:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Date: Thu, 24 Dec 2009 12:59:20 +0000
Message-ID: <b245135e0912240459j3ca92827sc69bb4665f60d8c3@mail.gmail.com>
Subject: Re: benchmark results
From: Teran McKinney <sega01@gmail.com>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

V2hpY2ggSS9PIHNjaGVkdWxlciBhcmUgeW91IHVzaW5nPyBQcmV0dHkgc3VyZSB0aGF0IFJlaXNl
ckZTIGlzIGEKbGl0dGxlIGxlc3MgZGVhZGxvY2t5IHdpdGggQ0ZRIG9yIGFub3RoZXIgb3ZlciBk
ZWFkbGluZSwgYnV0IHRoYXQKZGVhZGxpbmUgdXN1YWxseSBnaXZlcyB0aGUgYmVzdCByZXN1bHRz
IGZvciBtZSAoZXNwZWNpYWxseSBmb3IgSkZTKS4KClRoYW5rcywKVGVyYW4KCk9uIFRodSwgRGVj
IDI0LCAyMDA5IGF0IDEwOjMxLCBDaHJpc3RpYW4gS3VqYXUgPGxpc3RzQG5lcmRieW5hdHVyZS5k
ZT4gd3JvdGU6Cj4gSSd2ZSBoYWQgdGhlIGNoYW5jZSB0byB1c2UgYSB0ZXN0c3lzdGVtIGhlcmUg
YW5kIGNvdWxkbid0IHJlc2lzdCBydW5uaW5nIGEKPiBmZXcgYmVuY2htYXJrIHByb2dyYW1zIG9u
IHRoZW06IGJvbm5pZSsrLCB0aW9iZW5jaCwgZGJlbmNoIGFuZCBhIGZldwo+IGdlbmVyaWMgb25l
cyAoY3Avcm0vdGFyL2V0Yy4uLikgb24gZXh0ezIzNH0sIGJ0cmZzLCBqZnMsIHVmcywgeGZzLCB6
ZnMuCj4KPiBBbGwgd2l0aCBzdGFuZGFyZCBta2ZzL21vdW50IG9wdGlvbnMgYW5kICtub2F0aW1l
IGZvciBhbGwgb2YgdGhlbS4KPgo+IEhlcmUgYXJlIHRoZSByZXN1bHRzLCBubyBncmFwaHMgLSBz
b3JyeToKPiDCoCBodHRwOi8vbmVyZGJ5bmF0dXJlLmRlL2JlbmNobWFya3MvdjQwei8yMDA5LTEy
LTIyLwo+Cj4gUmVpc2VyZnMgaXMgbG9ja2luZyB1cCBkdXJpbmcgZGJlbmNoLCBzbyBJIHJlbW92
ZWQgaXQgZnJvbSB0aGUKPiBjb25maWcsIGhlcmUgYXJlIHNvbWUgZWFybGllciByZXN1bHRzOgo+
Cj4gwqAgaHR0cDovL25lcmRieW5hdHVyZS5kZS9iZW5jaG1hcmtzL3Y0MHovMjAwOS0xMi0yMS9i
b25uaWUuaHRtbAo+Cj4gQm9ubmllKysgY291bGRuJ3QgY29tcGxldGUgb24gbmlsZnMyLCBvbmx5
IHRoZSBnZW5lcmljIHRlc3RzCj4gYW5kIHRpb2JlbmNoIHdlcmUgcnVuLiBBcyBuaWxmczIsIHVm
cywgemZzIGFyZW4ndCBzdXBwb3J0aW5nIHhhdHRyLCBkYmVuY2gKPiBjb3VsZCBub3QgYmUgcnVu
IG9uIHRoZXNlIGZpbGVzeXN0ZW1zLgo+Cj4gU2hvcnQgc3VtbWFyeSwgQUZBSUNUOgo+IMKgIMKg
LSBidHJmcywgZXh0NCBhcmUgdGhlIG92ZXJhbGwgd2lubmVycwo+IMKgIMKgLSB4ZnMgdG8sIGJ1
dCBjcmVhdGluZy9kZWxldGluZyBtYW55IGZpbGVzIHdhcyAqdmVyeSogc2xvdwo+IMKgIMKgLSBp
ZiB5b3UgbmVlZCBvbmx5IGZhc3QgYnV0IG5vIGNvb2wgZmVhdHVyZXMgb3Igam91cm5hbGluZywg
ZXh0Mgo+IMKgIMKgIMKgaXMgc3RpbGwgYSBnb29kIGNob2ljZSA6KQo+Cj4gVGhhbmtzLAo+IENo
cmlzdGlhbi4KPiAtLQo+IEJPRkggZXhjdXNlICM4NDoKPgo+IFNvbWVvbmUgaXMgc3RhbmRpbmcg
b24gdGhlIGV0aGVybmV0IGNhYmxlLCBjYXVzaW5nIGEga2luayBpbiB0aGUgY2FibGUKPiAtLQo+
IFRvIHVuc3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5lICJ1bnN1YnNjcmli
ZSByZWlzZXJmcy1kZXZlbCIgaW4KPiB0aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8gbWFqb3Jkb21v
QHZnZXIua2VybmVsLm9yZwo+IE1vcmUgbWFqb3Jkb21vIGluZm8gYXQgwqBodHRwOi8vdmdlci5r
ZXJuZWwub3JnL21ham9yZG9tby1pbmZvLmh0bWwKPgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20K
aHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
