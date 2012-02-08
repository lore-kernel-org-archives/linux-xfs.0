Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q184uauF035460
	for <linux-xfs@oss.sgi.com>; Tue, 7 Feb 2012 22:56:36 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id FBVSt6YAACXYJLe5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 20:56:35 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Ruza6-0002Ga-6a
	for linux-xfs@oss.sgi.com; Wed, 08 Feb 2012 05:56:34 +0100
Received: from wombat.san-francisco.ca.us ([75.101.60.64])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 08 Feb 2012 05:56:34 +0100
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 08 Feb 2012 05:56:34 +0100
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: xfs_repair, xfs_metadump trouble with fs
Date: Tue, 07 Feb 2012 20:54:35 -0800
Message-ID: <bpb909x2jm.ln2@goaway.wombat.san-francisco.ca.us>
References: <nsa809x68g.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Hello again all,

On 2012-02-07, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
>
> So far, it has reported a large number of errors, but consistently gets
> stuck during phase 3.

I am not at all clear on what happened, but xfs_repair is no longer
stuck.  The downside is, it's finding a huge number of problems on the
filesystem.  What are the odds that the fs is actually usable when the
repair completes?  It's hard to imagine a repair that generates ~2GB of
output on stderr could be good news (so far; granted I did use -v).

--keith



-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
