Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1S8XDm6169671 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 02:33:14 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	38DuGpedB509BEOy (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 00:33:09 -0800 (PST)
Date: Tue, 28 Feb 2012 03:33:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS status update for January 2012
Message-ID: <20120228083308.GA22995@infradead.org>
References: <20120225120216.GA21721@infradead.org>
	<4F4B5CB3.8090107@cape-horn-eng.com>
	<4F4B7408.8020706@waagmeester.co.za>
	<4F4B7CB1.50102@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F4B7CB1.50102@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 27, 2012 at 01:53:05PM +0100, Richard Ems wrote:
> On 02/27/2012 01:16 PM, Coert Waagmeester wrote:
> 
> > Hello Richard,
> > 
> > Here I am running gentoo with kernel 3.2
> > In the 2.6 era I always mounted my xfs file systems with the delaylog
> > option, is this still necessary? Is delaylog now default?
> 
> Hi Coert,
> 
> I am running now 3.2.7 and the output of " grep xfs /proc/mounts " shows
> delaylog as being in use. I didn't put this option in /etc/fstab, so I
> think it must be default now.
> 
> But surely a developer can give a much better answer to your question.

Delaylog has been the default since Linux 2.6.39.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
