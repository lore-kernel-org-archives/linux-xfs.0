Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 68D927F37
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 09:07:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2496AC002
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 07:07:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id k2XJHXRtEgRTVr9T for <xfs@oss.sgi.com>;
	Thu, 03 Dec 2015 07:07:44 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 345C963C5A9F
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 09:07:44 -0600 (CST)
Subject: =?UTF-8?Q?Re:_=e7=ad=94=e5=a4=8d:_xfs=5fgrowfs_can_expand_capacity?=
	=?UTF-8?Q?=2cthen_how_to_reduce_xfs_filesystem_capacity=3f?=
References: <1CB94550540AE44E9CAAE8CD5AF40BF846D19CCC@H3CMLB12-EX.srv.huawei-3com.com>
	<20151203025620.GA1636@teal.hq.k1024.org>
	<1CB94550540AE44E9CAAE8CD5AF40BF846D1ADF9@H3CMLB12-EX.srv.huawei-3com.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56605ABF.7020405@sandeen.net>
Date: Thu, 3 Dec 2015 09:07:43 -0600
MIME-Version: 1.0
In-Reply-To: <1CB94550540AE44E9CAAE8CD5AF40BF846D1ADF9@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 12/3/15 2:27 AM, zhao.mingyue@h3c.com wrote:
> ubuntu  do not have xfsdump/xfsrestore, but it has xfs_metadump and xfs_mdrestore
> if I want to use xfsdump, what packages do I need to install?

if you want to use xfsdump, you need to install the xfsdump package:

https://launchpad.net/ubuntu/+source/xfsdump

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
