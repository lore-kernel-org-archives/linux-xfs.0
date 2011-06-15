Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5FExKXV191698 for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 09:59:20 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6CE412DB2B8
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 07:59:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rPBsBo2OSUekxMvx for <xfs@oss.sgi.com>;
	Wed, 15 Jun 2011 07:59:17 -0700 (PDT)
Date: Thu, 16 Jun 2011 00:59:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: auto group failing on kernel v2.6.38.5
Message-ID: <20110615145914.GF32466@dastard>
References: <BANLkTi=pgOCvn_2tdKXM6sLx_JKhzbrcEw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTi=pgOCvn_2tdKXM6sLx_JKhzbrcEw@mail.gmail.com>
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
To: Manish Aggarwal <mani.iitb@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 15, 2011 at 02:54:40PM +0530, Manish Aggarwal wrote:
> Hi I am running xfstest suite using command
> 
> ./check -xfs -g auto
> 
> PC x86 machine with Kernel version 2.6.38.5
> XFS Tests Suite dated 2011-05-11 (
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=summary)
> 
> 
> Many of the test cases are failing , please let me know thatt am I missing
> something?

Whatever it is, it's the same failures on the same test host with the
same configuration that your colleague Ajeet Yadav posted in this
thread:

http://oss.sgi.com/archives/xfs/2011-06/msg00190.html

Please followup to that thread and not start a new one...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
