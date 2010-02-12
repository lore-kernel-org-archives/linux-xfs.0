Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CK02Rl020443
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:00:03 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0091E13A2EB0
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:01:15 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	NrBEafCTqdPqNOZp for <linux-xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 12:01:15 -0800 (PST)
Received: by ewy27 with SMTP id 27so3000740ewy.18
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:01:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B7594D3.6040304@sandeen.net>
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>
	<4B75738D.80108@sandeen.net>
	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>
	<2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>
	<hl438l$bhm$1@ger.gmane.org> <4B7594D3.6040304@sandeen.net>
Date: Fri, 12 Feb 2010 21:01:11 +0100
Message-ID: <2d460de71002121201q224d3bc8xe48089eccdf6f6a@mail.gmail.com>
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
From: Richard Hartmann <richih.mailinglist@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com, Nicolas Stransky <nico@stransky.cx>

On Fri, Feb 12, 2010 at 18:50, Eric Sandeen <sandeen@sandeen.net> wrote:

> hard to say without knowing for sure what version you're using, and
> what exactly "this" is that you're seeing :)

3.0.4 - I stated that in another subthread so it might have gotten lost.


> Providing an xfs_metadump of the corrupted fs that hangs repair
> is also about the best thing you could do for investigation,
> if you've already determined that the latest release doesn't help.

http://dediserver.eu/misc/mailstore_metadata_obscured__after_xfs_repair_hang.bz2
http://dediserver.eu/misc/mailstore_metadata_obscured.bz2

These logs will stay up for at least a week or three.


Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
