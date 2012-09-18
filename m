Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8IIeuJV080938 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 13:40:56 -0500
Date: Tue, 18 Sep 2012 14:42:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
Message-ID: <20120918184201.GD28689@thunk.org>
References: <nsxa9wojdcd.fsf@closure.thunk.org>
	<20120918064039.GS11511@dastard> <50588898.6050802@sgi.com>
	<20120918181556.GC28689@thunk.org> <20120918182841.GA3343@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120918182841.GA3343@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Tue, Sep 18, 2012 at 01:28:41PM -0500, Ben Myers wrote:
> Your impression is just a few days out of date.  See:
> 
> http://oss.sgi.com/archives/xfs/2012-09/msg00156.html

On a unrelated note, has there been any thought about potentially
setting up a separate mailing list dedicated for xfstests?  I'm not
subscribed to the xfs mailing list, mainly because I was trying to
avoid adding yet another high volume mailing list to my inbox
(although to be fair, I guess it's only 25 messages per day even on
the busiest days), and so I've missed out on review of Dave's changes
to break out the tests into hierarchies, etc.  I wonder if there are
other xfstests users that aren't yet subscribed to the xfs mailing
list who would if there was a separate mailing list.

Not a big deal; if people really don't want a separate mailing list, I
guess I could subscribe to the xfs list as well...

      	      		       	   - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
