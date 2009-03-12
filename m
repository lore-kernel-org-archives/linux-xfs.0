Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CDBYUQ077379 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 08:11:55 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 726A01C38922
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 06:11:11 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id aEio5PJuYHmlBVUO for <xfs@oss.sgi.com>;
	Thu, 12 Mar 2009 06:11:11 -0700 (PDT)
Message-ID: <49B9097C.1070003@sandeen.net>
Date: Thu, 12 Mar 2009 08:09:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: LWN article: ext4 and data loss
References: <200903121239.35442@zmi.at>
In-Reply-To: <200903121239.35442@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> http://lwn.net/SubscriberLink/322823/e6979f02e5a73feb/
> 
> Very good, maybe similar patches for XFS would help?
> IANA Coder, but could be a hint.
> 
> mfg zmi
> 

ext4 is taking its hints from XFS in this regard, not the other way
around.  XFS dealt with this long ago.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
