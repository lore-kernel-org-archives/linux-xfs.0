Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0QM3PSH256297 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 16:03:25 -0600
Received: from caffeine.csclub.uwaterloo.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04E39BA507
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 14:02:42 -0800 (PST)
Received: from caffeine.csclub.uwaterloo.ca (caffeine.csclub.uwaterloo.ca
	[129.97.134.17]) by cuda.sgi.com with ESMTP id Njr953XFqD5fa4a5
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 14:02:42 -0800 (PST)
Date: Mon, 26 Jan 2009 17:02:11 -0500
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
Message-ID: <20090126220210.GB26064@csclub.uwaterloo.ca>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, xfs@oss.sgi.com

On Sun, Jan 25, 2009 at 07:15:40AM -0500, Justin Piszcz wrote:
> It comes with one :)
> # xfs_admin -u  /dev/sdd2
> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
> 
> Will try to use this to boot; however, I'd prefer the labels over the 
> UUID, wish there was an easy way to set it.

I prefer UUIDs.

Much mroe likely to have the same label on multiple drives than the same
UUID.  I don't want to have to worry about what label some usb device
might have if I happen to have it plugged in during a reboot.

Labels do tend to be shorter and more human readable of though.

-- 
Len Sorensen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
