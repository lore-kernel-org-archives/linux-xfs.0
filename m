Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D5C07F4E
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 07:41:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AC08BAC003
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 05:41:45 -0800 (PST)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
	[209.85.217.175]) by cuda.sgi.com with ESMTP id
	NdQzGg20BZXGk42D (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 05:41:36 -0800 (PST)
Received: by lbvp9 with SMTP id p9so27703546lbv.10
	for <xfs@oss.sgi.com>; Sat, 07 Mar 2015 05:41:34 -0800 (PST)
Received: from xps.localnet (85-222-71-204.dynamic.chello.pl. [85.222.71.204])
	by mx.google.com with ESMTPSA id
	pq1sm2316928lbb.41.2015.03.07.05.41.33 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sat, 07 Mar 2015 05:41:33 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
Date: Sat, 7 Mar 2015 14:41:32 +0100
References: <54EC958E.2000001@pythonanywhere.com>
	<54F895FA.4050205@sandeen.net>
	<54F89B47.4010702@pythonanywhere.com>
In-Reply-To: <54F89B47.4010702@pythonanywhere.com>
MIME-Version: 1.0
Message-Id: <201503071441.32654.arekm@maven.pl>
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

T24gVGh1cnNkYXkgMDUgb2YgTWFyY2ggMjAxNSwgSGFycnkgd3JvdGU6Cj4gSGVyZSdzIHRoZSBz
eXNsb2csIGlmIHlvdSdyZSBjdXJpb3VzLgo+IAo+IGh0dHA6Ly9wYXN0ZWJpbi5jb20vcmF3LnBo
cD9pPWtLdldKY3plCj4gCj4gU2VhcmNoIGZvciAiRmFpbGVkIHRvIGluaXRpYWxpemUiCgpXaGF0
IGRvZXMKCnhmc19kYiAvZGV2L2RyYmQwIC1jICJzYiAwIiAtYyAicHJpbnQiIHxncmVwIHF1b3QK
CnNob3c/CgotLSAKQXJrYWRpdXN6IE1pxZtraWV3aWN6LCBhcmVrbSAvICggbWF2ZW4ucGwgfCBw
bGQtbGludXgub3JnICkKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
