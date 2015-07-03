Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2166E7F83
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 10:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1598AC006
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 08:24:10 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id pUU3LMbJMMy9cMar (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 08:24:05 -0700 (PDT)
Date: Fri, 3 Jul 2015 17:24:08 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Message-ID: <20150703172408.52212ba6@harpe.intellique.com>
In-Reply-To: <E293B208-AA72-4076-97B0-753C8680D1AE@intomics.com>
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
	<09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
	<DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
	<20150702112623.1c83d473@harpe.intellique.com>
	<E293B208-AA72-4076-97B0-753C8680D1AE@intomics.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rasmus Borup Hansen <rbh@intomics.com>
Cc: xfs@oss.sgi.com

TGUgRnJpLCAzIEp1bCAyMDE1IDA4OjI3OjI4ICswMjAwClJhc211cyBCb3J1cCBIYW5zZW4gPHJi
aEBpbnRvbWljcy5jb20+IMOpY3JpdmFpdDoKCj4gVGhhbmsgeW91IGZvciB0aGUgc3VnZ2VzdGlv
bi4gSSBjb21waWxlZCBhIG5ldyB4ZnNfcmVwYWlyLCBidXQgSSBnb3QKPiBzaW1pbGFyIHJlc3Vs
dHMgZnJvbSBydW5uaW5nIGl0Lgo+IAoKR2V0IHRoZSBpbm9kZSBudW1iZXIgb2YgdGhlIGZhdWx0
eSBmaWxlLCB1bW91bnQgdGhlIHZvbHVtZSwgb3BlbiBpdAp3aXRoIHhmc19kYiBhbmQgcmVtb3Zl
IHRoZSBmaWxlIHRocm91Z2ggaXQ6CgpodHRwOi8veGZzLm9yZy9pbmRleC5waHAvWEZTX0ZBUSNR
Ol9Ib3dfdG9fZ2V0X2Fyb3VuZF9hX2JhZF9pbm9kZV9yZXBhaXJfaXNfdW5hYmxlX3RvX2NsZWFu
X3VwCgotLSAKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCkVtbWFudWVsIEZsb3JhYyAgICAgfCAgIERpcmVjdGlv
biB0ZWNobmlxdWUKICAgICAgICAgICAgICAgICAgICB8ICAgSW50ZWxsaXF1ZQogICAgICAgICAg
ICAgICAgICAgIHwJPGVmbG9yYWNAaW50ZWxsaXF1ZS5jb20+CiAgICAgICAgICAgICAgICAgICAg
fCAgICszMyAxIDc4IDk0IDg0IDAyCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
