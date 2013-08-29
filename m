Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A0367F6B
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 12:48:32 -0500 (CDT)
Date: Thu, 29 Aug 2013 12:48:27 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
Message-ID: <20130829174827.GF7153@sgi.com>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<20130821064357.GA8822@infradead.org>
	<20130821130152.GA9709@quack.suse.cz>
	<20130821181247.GL5262@sgi.com>
	<20130821181919.GA21378@infradead.org>
	<1377119720.17321.6.camel@chandra-laptop.ibm.com>
	<1377795600.5925.1.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377795600.5925.1.camel@chandra-dt.ibm.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Abhijith Das <adas@redhat.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>

Hey,

On Thu, Aug 29, 2013 at 12:00:00PM -0500, Chandra Seetharaman wrote:
> Christoph, Dave, Ben,
> 
> What you suggest I should do w.r.t this patch ?

My impression is that Christoph is ok with not reverting the patch for
now, but requested that some cleanups be made soonish.  I suggest you
let it stand as is for now, and try to address his suggestions in a
subsequent patch.

Christoph, could you make it clearer what you'd like seen to?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
