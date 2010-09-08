Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88IZFWm053795 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 13:35:16 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F05B1E610C5
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 11:35:59 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id YQLWVPzxQLTzg80S
	for <xfs@oss.sgi.com>; Wed, 08 Sep 2010 11:35:59 -0700 (PDT)
Received: by bwz1 with SMTP id 1so401362bwz.26
	for <xfs@oss.sgi.com>; Wed, 08 Sep 2010 11:35:59 -0700 (PDT)
Message-ID: <4C87D793.8000103@googlemail.com>
Date: Wed, 08 Sep 2010 20:36:03 +0200
From: Marcus Osdoba <marcus.osdoba@googlemail.com>
MIME-Version: 1.0
Subject: Re: xfs on armv5 still with erroneous log in kernel 2.6.35.4
References: <4C835A34.9080008@googlemail.com> <20100906005230.GX7362@dastard>
	<4C845EDE.3010806@sandeen.net> <4C8534D0.3050003@googlemail.com>
	<20100907060331.GK705@dastard> <4C86B4E3.5090202@googlemail.com>
	<20100908074357.GS705@dastard>
In-Reply-To: <20100908074357.GS705@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

ICBBbSAwOC4wOS4yMDEwIDA5OjQzLCBzY2hyaWViIERhdmUgQ2hpbm5lcjoKPgo+IEZXSVcsIHBs
ZWFzZSBjb3B5IHRoZSBleGFjdCBjb21tYW5kcyBhbmQgZXJyb3JzIGZyb20geW91ciB0ZXJtaW5h
bCAtCj4gcGFyYXBocmFzaW5nIHRoZW0gbGlrZSB0aGlzIGRvZXMgbm90IGhlbHAgbWUgdW5kZXLR
lXRhbmQgZXhhY3RseSB3aGF0Cj4gaXMgaGFwcGVuaW5nLi4uCkhpIERhdmUsCgpJJ20gdmVyeSBz
b3JyeSBmb3IgYW5ub3lpbmcgeW91LiBQbGVhc2UgZXhjdXNlIHRoaXMuCgpZb3UgYXNrZWQgbWUg
dG8gY29weSB0aGUgZXhhY3QgY29tbWFuZHMgZnJvbSB0aGUgdGVybWluYWwuIEkgZGlkIHRoYXQg
CmRlc3BpdGUgdGhlIGZhY3QsIHRoYXQgSSByZXBsYWNlZCAiY3AgL2Jpbi8qIC9kYXRhIiB3aXRo
ICJjcCBzb21ldGhpbmcgCm9uIGl0Ii4gQWxsIG90aGVyIGNvbW1hbmRzIGFyZSAxMDAlIHRoZSBz
YW1lIGluIGV4YWN0bHkgdGhlIGdpdmVuIG9yZGVyIAppbiB0aGUgZm9ybWVyIG1haWwuCkZ1cnRo
ZXJtb3JlIHlvdSBhc2tlZCBtZSB0byBnaXZlIHRoZSBvdXRwdXQgb2YgeGZzX3ByaW50bG9nIHdp
dGggYW5kIAp3aXRob3V0IG9wdGlvbiAtdC4gSSBnYXZlIHRoYXQgb3V0cHV0IGluIHRoZSBsYXN0
IG1haWwsIHRvby4KClBsZWFzZSB0YWtlIG15IGFwb2xvZ2llcyBhbmQgbm90ZSB0aGUgd29ya2Zs
b3cgSSBoYXZlIHRlc3RlZDoKCiA+bW91bnQgLXQgeGZzIC9kZXYvc2RhMSAvZGF0YQogPmNwIC9i
aW4vc2ggL2RhdGEKID5zeW5jCiA+dW1vdW50IC9kYXRhCiA+eGZzX3ByaW50bG9nIC9kZXYvc2Rh
MQojbm8gRVJST1IgZW50cnkgdmlzaWJsZQogPm1vdW50IC10IHhmcyAvZGV2L3NkYTEgL2RhdGEK
I3JlIG1vdW50aW5nIHdvcmtzIGZpbmUsIG5vIHByb2JsZW1zISwKI3NvIEkgdGhvdWdodCBydW5u
aW5nIGEgc3luYyBiZWZvcmUgdGhlIHVtb3VudCB3b3VsZCBzb2x2ZSBteSBlcnJvbmVvdXMgCmxv
ZyBwcm9ibGVtIG9uIEFSTSBkZXZpY2VzCgojIFRoZSBmb2xsb3dpbmcgY29tbWFuZCBjaGFpbiB0
cnlzIHRvIHJlcHJvZHVjZSB0aGUgZXJyb3IKID5tb3VudCAtdCB4ZnMgL2Rldi9zZGExIC9kYXRh
CiA+Y3AgL2Jpbi8qIC9kYXRhCiA+c3luYwpEZXZpY2Ugb3IgcmVzb3VyY2UgYnVzeS4KID5zeW5j
CiA+dW1vdW50IC9kYXRhCiA+eGZzX3ByaW50bG9nIC9kZXYvc2RhMQojaW5jbHVkZXMgYW4gRVJS
T1IgZW50cnkgYXQgdGhlIGVuZCwgc2VlIGxhc3QgbWFpbAoKVGhlIG91dHB1dCBvZiBkbWVzZyBh
ZnRlciB0cnlpbmcgdG8gbW91bnQgYSBwYXJ0aXRpb24gb24gd2hpY2ggSSB3cm90ZSAKc29tZSBm
aWxlcyBiZWZvcmUsCkkgZ2F2ZSBpbiB0aGUgdmVyeSBmaXJzdCBtYWlsOgoiClNHSSBYRlMgd2l0
aCBBQ0xzLCBzZWN1cml0eSBhdHRyaWJ1dGVzLCBsYXJnZSBibG9jay9pbm9kZSBudW1iZXJzLCBu
byAKZGVidWcgZW5hYmxlZApTR0kgWEZTIFF1b3RhIE1hbmFnZW1lbnQgc3Vic3lzdGVtClhGUyBt
b3VudGluZyBmaWxlc3lzdGVtIHNkYTEKU3RhcnRpbmcgWEZTIHJlY292ZXJ5IG9uIGZpbGVzeXN0
ZW06IHNkYTEgKGxvZ2RldjogaW50ZXJuYWwpClhGUzogeGxvZ19yZWNvdmVyX3Byb2Nlc3NfZGF0
YTogYmFkIGNsaWVudGlkClhGUzogbG9nIG1vdW50L3JlY292ZXJ5IGZhaWxlZDogZXJyb3IgNQpY
RlM6IGxvZyBtb3VudCBmYWlsZWQKIgoKTXkgZXhwZWN0YXRpb25zOgotIHN5bmMgc2hvdWxkIG5l
dmVyIGJlIG1hbmRhdG9yeSBiZWZvcmUgIHVubW91bnRpbmcgdG8ga2VlcCB0aGUgRlMgY2xlYW4g
CihhbnkgRlMpCi0gdW1vdW50IHNob3VsZCBuZXZlciBicmVhayB0aGUgbG9nIG9mIHRoZSBGUwoK
RmFjdHM6Ck1vdW50aW5nIHRoZSBYRlMtUGFydHRpdGlvbiwgd3JpdGluZyBzb21lIGRhdGEgb24g
aXQgYW5kIHVubW91bnRpbmcgCnJlc3VsdHMgaW4gYW4gZXJyb25lb3VzIGxvZyB3aGljaCBmb3Jj
ZXMgYSB4ZnNfcmVwYWlyIC1MIG9uIHRoZSBuZXh0IG1vdW50LgooVGhpcyBJIGRvIG5vdCBleHBl
Y3QgZWl0aGVyLi4uKQoKSSBkbyBub3Qga25vdyB3aGljaCBkZWJ1ZyBwcm9jZWR1cmVzIGFyZSB1
c2VmdWwgYW5kIHdvdWxkIGdpdmUgeW91IHNvbWUgCnVzZWZ1bCBvdXRwdXQuIFNvcnJ5IGFib3V0
IHRoaXMuCgpBZnRlciBzdW1taW5nIHVwIHRoZSBjb250ZW50IEkgZ2F2ZSBpbiB0aGUgbWFpbGNo
YWluLCBwbGVhc2UgbGV0IG1lIAprbm93LCBpZiBzb2x2aW5nIHRoaXMgaXNzdWUgaGFzIGFueSBj
aGFuY2Ugb2Ygc3VjY2Vzcy4KClRoYW5rcyBhbmQga2luZCByZWdhcmRzLApNYXJjdXMKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxp
c3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hm
cwo=
