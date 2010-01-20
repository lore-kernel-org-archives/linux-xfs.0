Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0KM1A9n035135 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 16:01:10 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EDBA124EF81
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:02:09 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	sPmPG28eODWjJCeF for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2010 14:02:09 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11654113-1927428
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 08:32:08 +1030 (CDT)
Received: from dave by discord with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>) id 1NXico-00069s-Oz
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 09:02:06 +1100
Date: Thu, 21 Jan 2010 09:02:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/8] xfstests: fix compile warnings
Message-ID: <20100120220206.GN14035@discord.disaster>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263958688-435-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Wed, Jan 20, 2010 at 02:38:00PM +1100, Dave Chinner wrote:
> This series fixes all the compile warnings when building xfstests.
> It doesn't deal with the dmapi subdirectory but cleans everything else
> up.

Pushed into xfstests-dev tree.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
