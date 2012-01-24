Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHiTuM059101 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:44:29 -0600
Date: Tue, 24 Jan 2012 11:44:28 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: XFS update for 3.2-stable
Message-ID: <20120124174428.GR8262@sgi.com>
References: <1326919305-2753-1-git-send-email-bpm@sgi.com>
	<20120122211340.GC3224@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120122211340.GC3224@kroah.com>
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
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

Hey Greg,

On Sun, Jan 22, 2012 at 02:13:40PM -0700, Greg KH wrote:
> On Wed, Jan 18, 2012 at 02:41:44PM -0600, bpm@sgi.com wrote:
> > Here's a fix for 3.2-stable related to trim support in xfs.
> 
> Applied, thanks.  Is it also needed for the 3.0-stable tree?

Looks like it.  I'll submit it for 3.0...

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
