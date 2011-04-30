Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3UJoV1W135490 for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 14:50:31 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34D6211ADBA0
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 12:54:05 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CPnDTWAf5BW8rX8p
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 12:54:05 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C094F6C129
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 14:54:04 -0500 (CDT)
Message-ID: <4DBC68DA.1090708@hardwarefreak.com>
Date: Sat, 30 Apr 2011 14:54:02 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
	<20110430180213.6dcfc41c@galadriel2.home>
In-Reply-To: <20110430180213.6dcfc41c@galadriel2.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

T24gNC8zMC8yMDExIDExOjAyIEFNLCBFbW1hbnVlbCBGbG9yYWMgd3JvdGU6Cj4gTGUgU2F0LCAz
MCBBcHIgMjAxMSAxNjoyNzo0OCArMDEwMCB2b3VzIMOpY3JpdmllejoKCj4+IEhvdyBiYWQgY2Fu
IHRoaXMgYmUgd2hlbiB0aGUgam91cm5hbCBpcyBzYXkgaW50ZXJuYWwgZm9yIGEKPj4gZmlsZXN5
c3RlbSB0aGF0IGlzIGhlbGQgb24gd2lkZS1zdHJpZGUgUkFJRDYgc2V0Pwo+Cj4gTm90IHRoYXQg
YmFkIGJlY2F1c2UgdHlwaWNhbGx5IHRoZSBqb3VybmFsIGlzIHNtYWxsIGVub3VnaCB0byBmaXQK
PiBlbnRpcmVseSBpbiB0aGUgY29udHJvbGxlciBjYWNoZS4KPgo+PiBJIHN1c3BlY3QgdmVyeQo+
PiB2ZXJ5IGJhZCwgd2l0aCBhcG9jYWx5cHRpYyByZWFkLW1vZGlmeS13cml0ZSBzdG9ybXMsIGVh
dGluZyBJT1BTLgo+Cj4gTm90IGlmIHlvdSdyZSB1c2luZyB3cml0ZS1iYWNrIGNhY2hlLgoKSnVz
dCBoYXZpbmcgd3JpdGUgYmFjayBjYWNoZSBpc24ndCBtYWdpYyBieSBpdHNlbGYuICBUaGUgY2Fj
aGUgCm1hbmFnZW1lbnQgYWxnb3JpdGhtIGFuZCBjb25maWd1cmF0aW9uIHRoZXJlb2YgYXJlIG9m
dGVuIGFzIGltcG9ydGFudCwgCmlmIG5vdCBtb3JlLCB0aGFuIHRoZSB0b3RhbCBjYWNoZSBzaXpl
IG9uIHRoZSBSQUlEIEhCQSBvciBTQU4gY29udHJvbGxlci4KClBvb3IgY2FjaGUgbWFuYWdlbWVu
dCwgSSdkIGd1ZXNzLCBpcyBvbmUgcmVhc29uIHdoeSB5b3Ugc2VlIEFyZWNhIFJBSUQgCmNhcmRz
IHdpdGggMS00R0IgY2FjaGUgRFJBTSB3aGVyZWFzIGNvbXBldGluZyBjYXJkcyB3LyBzaW1pbGFy
IApwcmljZS9wZXJmb3JtYW5jZS9mZWF0dXJlcyBmcm9tIExTSSwgQWRhcHRlYywgYW5kIG90aGVy
cyBzcG9ydCA1MTJNQi4KCi0tIApTdGFuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
