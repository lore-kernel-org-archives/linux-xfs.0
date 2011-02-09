Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p19GNF3J006444 for <xfs@oss.sgi.com>; Wed, 9 Feb 2011 10:23:16 -0600
Subject: Re: [PATCH v3] Add test 249: Check filesystem FITRIM implementation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <alpine.LFD.2.00.1102091309560.32212@dhcp-27-109.brq.redhat.com>
References: <1296762207-17265-1-git-send-email-lczerner@redhat.com>
	<1297167619.7351.29.camel@doink>
	<alpine.LFD.2.00.1102091309560.32212@dhcp-27-109.brq.redhat.com>
Date: Wed, 09 Feb 2011 10:24:00 -0600
Message-ID: <1297268640.2513.0.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, esandeen@redhat.com, xfs@oss.sgi.com

On Wed, 2011-02-09 at 13:13 +0100, Lukas Czerner wrote:
> 
> One more thing though. Where did you get the number 252 ? This patch
> still apply cleanly on the top of the master branch. I am using this
> repo: 
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> Shall I use a different one ? Which one is the most up-to-date ? 

Like I said, use what works for you, and when the time
comes to commit it I will update all the numbers for you
to match what's current.  I've been testing with some
other tests not yet committed.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
