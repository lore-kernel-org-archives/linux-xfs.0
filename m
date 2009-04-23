Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3N6IH8K247502 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 01:18:17 -0500
Received: from idcmail-mo1so.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD5B71CDFA19
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 23:18:14 -0700 (PDT)
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by
	cuda.sgi.com with ESMTP id hU3N2gder1XwYDMq for
	<xfs@oss.sgi.com>; Wed, 22 Apr 2009 23:18:14 -0700 (PDT)
Received: from bender.lan.kevinjamieson.com (bender.lan.kevinjamieson.com
	[192.168.1.110])
	by mail.kevinjamieson.com (Postfix) with ESMTP id 2388220058
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 23:18:11 -0700 (PDT)
Message-ID: <49F00823.6050908@kevinjamieson.com>
Date: Wed, 22 Apr 2009 23:18:11 -0700
From: Kevin Jamieson <kevin@kevinjamieson.com>
MIME-Version: 1.0
Subject: Re: Oops at xfs_bmbt_get_startoff in SLES 10 2.6.16
References: <64323.24.80.224.145.1236883814.squirrel@squirrel.kevinjamieson.com>	<49B9611F.5040009@sandeen.net>	<58707.24.80.224.145.1236899620.squirrel@squirrel.kevinjamieson.com>
	<53630.24.80.224.145.1240361692.squirrel@squirrel.kevinjamieson.com>
	<49EE7E17.8050006@sandeen.net>
In-Reply-To: <49EE7E17.8050006@sandeen.net>
Reply-To: kevin@kevinjamieson.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Eric Sandeen wrote:

> And you hit it pretty reliably before, right?

Yes, fairly regularly -- about 2-3 times per week under the same workload.

Kevin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
