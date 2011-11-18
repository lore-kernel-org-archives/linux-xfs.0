Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAI74DsX104238 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 01:04:13 -0600
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E44112722E9
	for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 23:04:09 -0800 (PST)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id S7bBDVjRMIeyo5Rr
	for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 23:04:09 -0800 (PST)
Received: by bkaq10 with SMTP id q10so3318932bka.26
	for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 23:04:09 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH 3/3] xfsprogs: allow linking against libtcmalloc
Date: Fri, 18 Nov 2011 08:04:06 +0100
References: <20111114155742.285135418@bombadil.infradead.org>
	<20111114160217.591812422@bombadil.infradead.org>
In-Reply-To: <20111114160217.591812422@bombadil.infradead.org>
MIME-Version: 1.0
Message-Id: <201111180804.06413.arekm@maven.pl>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

T24gTW9uZGF5IDE0IG9mIE5vdmVtYmVyIDIwMTEsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+
IEFsbG93IGxpbmtpbmcgYWdhaW5zdCB0aGUgbGlidGNtYWxsb2MgbGlicmFyeSBmcm9tIEdvb2ds
ZSdzIHBlcmZvcm1hbmNlCj4gdG9vbHMsIHdoaWNoIGF0IGxlYXN0IGZvciByZXBhaXIgcmVkdWNl
cyB0aGUgbWVtb3J5IHVzYWdlIGRyYW1hdGljYWxseS4KClNob3VsZCAtZm5vLWJ1aWx0aW4tbWFs
bG9jIGJlIGFsc28gdXNlZD8KCi0tLSB4ZnNwcm9ncy0zLjEuNy9jb25maWd1cmUuaW4ub3JnCTIw
MTEtMTEtMTggMDc6NTg6NDkuODE1NDM5Njk5ICswMTAwCisrKyB4ZnNwcm9ncy0zLjEuNy9jb25m
aWd1cmUuaW4JMjAxMS0xMS0xOCAwNzo1OTo0OS4zNjAwOTMwMDEgKzAxMDAKQEAgLTMxLDYgKzMx
LDI2IEBACiBBQ19TVUJTVChsaWJlZGl0bGluZSkKIEFDX1NVQlNUKGVuYWJsZV9lZGl0bGluZSkK
IAorQUNfQVJHX0VOQUJMRSh0Y21hbGxvYywKK1sgLS1lbmFibGUtdGNtYWxsb2M9W3llcy9ub10g
RW5hYmxlIHRjbWFsbG9jIFtkZWZhdWx0PW5vXV0sLAorCWVuYWJsZV90Y21hbGxvYz1jaGVjaykK
KworaWYgdGVzdCB4JGVuYWJsZV90Y21hbGxvYyAhPSB4bm87IHRoZW4KKyAgICBzYXZlZF9DUFBG
TEFHUz0iJENQUEZMQUdTIgorICAgIENQUEZMQUdTPSIkQ1BQRkxBR1MgLWZuby1idWlsdGluLW1h
bGxvYyIKKyAgICBBQ19DSEVDS19MSUIoW3RjbWFsbG9jX21pbmltYWxdLCBbbWFsbG9jXSwgW2xp
YnRjbWFsbG9jPSItbHRjbWFsbG9jX21pbmltYWwiXSwKKyAgICAgIFtBQ19DSEVDS19MSUIoW3Rj
bWFsbG9jXSwgW21hbGxvY10sIFtsaWJ0Y21hbGxvYz0iLWx0Y21hbGxvYyJdLCBbCisJaWYgdGVz
dCB4JGVuYWJsZV90Y21hbGxvYyA9IHh5ZXM7IHRoZW4KKwkJQUNfTVNHX0VSUk9SKFtsaWJ0Y21h
bGxvY19taW5pbWFsIG9yIGxpYnRjbWFsbG9jIGxpYnJhcnkgbm90IGZvdW5kXSwgMSkKKwlmaV0K
KyAgICAgICldCisgICAgKQorICAgIGlmIHRlc3QgeCRsaWJ0Y21hbGxvYyA9IHg7IHRoZW4KKwlD
UFBGTEFHUz0iJHNhdmVkX0NQUEZMQUdTIgorICAgIGZpCitmaQorQUNfU1VCU1QobGlidGNtYWxs
b2MpCisKIEFDX0FSR19FTkFCTEUodGVybWNhcCwKIFsgLS1lbmFibGUtdGVybWNhcD1beWVzL25v
XSBFbmFibGUgdGVybWluYWwgY2FwYWJpbGl0aWVzIGxpYnJhcnkgW2RlZmF1bHQ9bm9dXSwKIAl0
ZXN0ICRlbmFibGVfdGVybWNhcCA9IHllcyAmJiBsaWJ0ZXJtY2FwPSItbHRlcm1jYXAiLCkKSW5k
ZXg6IHhmc3Byb2dzLWRldi9pbmNsdWRlL2J1aWxkZGVmcy5pbgo9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSB4ZnNw
cm9ncy1kZXYub3JpZy9pbmNsdWRlL2J1aWxkZGVmcy5pbgkyMDExLTA4LTE0IDE3OjAwOjAyLjAw
MDAwMDAwMCArMDAwMAorKysgeGZzcHJvZ3MtZGV2L2luY2x1ZGUvYnVpbGRkZWZzLmluCTIwMTEt
MTEtMTQgMTI6MDk6NTIuMDAwMDAwMDAwICswMDAwCkBAIC0yMiw3ICsyMiw3IEBAIF9CVUlMRERF
RlNfSU5DTFVERURfID0gMQogCiBERUJVRyA9IEBkZWJ1Z19idWlsZEAKIE9QVElNSVpFUiA9IEBv
cHRfYnVpbGRACi1NQUxMT0NMSUIgPSBAbWFsbG9jX2xpYkAKK01BTExPQ0xJQiA9IEBtYWxsb2Nf
bGliQCBAbGlidGNtYWxsb2NACiBMT0FERVJGTEFHUyA9IEBMREZMQUdTQAogTFRMREZMQUdTID0g
QExERkxBR1NACiBDRkxBR1MgPSBAQ0ZMQUdTQAoKCgotLSAKQXJrYWRpdXN6IE1pxZtraWV3aWN6
ICAgICAgICBQTEQvTGludXggVGVhbQphcmVrbSAvIG1hdmVuLnBsICAgICAgICAgICAgaHR0cDov
L2Z0cC5wbGQtbGludXgub3JnLwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5z
Z2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
