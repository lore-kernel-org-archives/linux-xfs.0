Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p56GU9xw239264
	for <linux-xfs@oss.sgi.com>; Mon, 6 Jun 2011 11:30:12 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D96971E3F447
	for <linux-xfs@oss.sgi.com>; Mon,  6 Jun 2011 09:30:06 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id 60bc7fBZzaLmKIXm for <linux-xfs@oss.sgi.com>;
	Mon, 06 Jun 2011 09:30:06 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QTcgn-0007kJ-Ac
	for linux-xfs@oss.sgi.com; Mon, 06 Jun 2011 18:30:05 +0200
Received: from s0106000acd1d509c.du.shawcable.net ([70.67.174.161])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 06 Jun 2011 18:30:05 +0200
Received: from prad by s0106000acd1d509c.du.shawcable.net with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 06 Jun 2011 18:30:05 +0200
From: prad <prad@towardsfreedom.com>
Subject: Re: altering defaults
Date: Mon, 06 Jun 2011 09:26:27 -0700
Message-ID: <871uz7lydo.fsf@psinom.home>
References: <8762onaq19.fsf@psinom.home> <4DEC4DE0.5090503@sandeen.net>
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

Eric Sandeen <sandeen@sandeen.net> writes:

> If space efficiency is a consideration then smaller blocksizes might
> be useful.  Not so much for hits per day, but for how many files you
> expect to store at any one time; you'll waste ((blocksize / 2) * nr
> files) on average.
>
space is not likely an issue at all.
if there is no efficiency issue the usage of 4096 bytes hardly seems
significant.

so thx eric and michael for your input on this!
we'll leave things alone. :D

-- 
in friendship,
prad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
