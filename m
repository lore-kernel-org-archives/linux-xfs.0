Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24F057F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:30:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C981AC002
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 19:30:01 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DUEDbIjXyHyGX7MT for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 19:29:51 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B966E63C5A9F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:29:50 -0600 (CST)
Subject: Re: xfs_growfs can expand capacity, then how to reduce xfs filesystem
	capacity?
References: <1CB94550540AE44E9CAAE8CD5AF40BF846D19CCC@H3CMLB12-EX.srv.huawei-3com.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565FB72E.8070004@sandeen.net>
Date: Wed, 2 Dec 2015 21:29:50 -0600
MIME-Version: 1.0
In-Reply-To: <1CB94550540AE44E9CAAE8CD5AF40BF846D19CCC@H3CMLB12-EX.srv.huawei-3com.com>
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



On 12/2/15 8:33 PM, zhao.mingyue@h3c.com wrote:
> hi,
>   I know that xfs_growfs can expand xfs capacity,now I want to reduce the capacity,but I don't know the command.can someone help me ?

http://xfs.org/index.php/XFS_FAQ#Q:_Is_there_a_way_to_make_a_XFS_filesystem_larger_or_smaller.3F

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
