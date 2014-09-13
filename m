Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 866267F50
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 09:43:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF4FFAC001
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 07:43:41 -0700 (PDT)
Received: from mail-we0-f172.google.com (mail-we0-f172.google.com
	[74.125.82.172]) by cuda.sgi.com with ESMTP id DiHxH1Kcpd2DMX3x
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Sep 2014 07:43:40 -0700 (PDT)
Received: by mail-we0-f172.google.com with SMTP id k48so1997469wev.17
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 07:43:39 -0700 (PDT)
Received: from Telcontar.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id dc9sm5110730wib.5.2014.09.13.07.43.38
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sat, 13 Sep 2014 07:43:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id EB99A6128B
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 16:43:33 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id exiH_aFm4EtH for <xfs@oss.sgi.com>;
	Sat, 13 Sep 2014 16:43:32 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 7B6326066F
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 16:43:31 +0200 (CEST)
Message-ID: <54145812.7070100@opensuse.org>
Date: Sat, 13 Sep 2014 16:43:30 +0200
From: "Carlos E. R." <carlos.e.r@opensuse.org>
MIME-Version: 1.0
Subject: Re: unclean shutdown of usb hdd destroyed xfs partially
References: <3999c95c0dc7ebfdfbb2853a6d13f7dc@zbfmail.de>
In-Reply-To: <3999c95c0dc7ebfdfbb2853a6d13f7dc@zbfmail.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

LS0tLS1CRUdJTiBQR1AgU0lHTkVEIE1FU1NBR0UtLS0tLQpIYXNoOiBTSEExCgpPbiAyMDE0LTA5
LTEzIDE2OjMzLCBNYXJrbyBXZWJlcnw4MDAwIHdyb3RlOgoKPiAjIGxzIC1sIC9tbnQvdGVtcCBs
czogWnVncmlmZiBhdWYgL21udC90ZW1wL3NlcmllbiBuaWNodCBtw7ZnbGljaDoKPiBEaWUgU3Ry
dWt0dXIgbXVzcyBiZXJlaW5pZ3Qgd2VyZGVuCgouLi4KCj4gdGhlIGFib3ZlIGxpbmVzIHdpdGgg
bHMgc2F5cyAiYWNjZXNzIG5vdCBwb3NzaWJsZSBvbiBzZXJpZW4gYW5kCj4gZG9rdXR2LCBzdHJ1
Y3R1cmUgbmVlZHMgY2xlYW5pbmcuCgpKdXN0IGEgY29tbWVudC4gWW91IGNhbiBpc3N1ZSBjb21t
YW5kcyBsaWtlIHRoaXM6CgpMQU5HPUMgbHMgLWwgL21udC90ZW1wCgphbmQgdGhlIG91dHB1dCB3
aWxsIGJlLCBmb3IgdGhhdCB0aW1lIG9ubHksIGluIEVuZ2xpc2gsIHNvIHRoYXQgd2UgY2FuCmFs
bCByZWFkIGl0IDstKQoKLSAtLSAKQ2hlZXJzIC8gU2FsdWRvcywKCgkJQ2FybG9zIEUuIFIuCgkJ
KGZyb20gMTMuMSB4ODZfNjQgIkJvdHRsZSIgYXQgVGVsY29udGFyKQotLS0tLUJFR0lOIFBHUCBT
SUdOQVRVUkUtLS0tLQpWZXJzaW9uOiBHbnVQRyB2Mi4wLjIyIChHTlUvTGludXgpCgppRVlFQVJF
Q0FBWUZBbFFVV0JBQUNna1F0VE1ZSEcyTlI5V3NsZ0NlTkNzQWlRQTIxVWFRV2wyOHFpcEx3T1RL
Cm5uc0FuMDkvb1Fsc3JrRHdsRjJUWXpudW1nSzVzWG5JCj1pcEtlCi0tLS0tRU5EIFBHUCBTSUdO
QVRVUkUtLS0tLQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
