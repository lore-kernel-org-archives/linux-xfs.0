Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 83C518051
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 11:41:22 -0600 (CST)
Date: Mon, 4 Mar 2013 11:41:21 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/9] xfs: add CRC checks to the AGI
Message-ID: <20130304174121.GI22182@sgi.com>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<1358774760-21841-6-git-send-email-david@fromorbit.com>
	<20130304174012.GH22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130304174012.GH22182@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 04, 2013 at 11:40:12AM -0600, Ben Myers wrote:
> On Tue, Jan 22, 2013 at 12:25:56AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dgc@sgi.com>
> > 
> > Same set of changes made to the AGF need to be made to the AGI.
> > This patch has a similar history to the AGF, hence a similar
> > sign-off chain.
> > 
> > Signed-off-by: Dave Chinner <dgc@sgi.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Dave Chinner <dgc@redhat.com>
> 
> This one looks fine to me.

Meh.  I meant to reply to the v2 posting.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
