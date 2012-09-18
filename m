Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8IIJ5O9078858 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 13:19:05 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 6EmFkWqnhfdXqyBD for <xfs@oss.sgi.com>;
	Tue, 18 Sep 2012 11:20:16 -0700 (PDT)
Message-ID: <5058BB5F.5050506@sandeen.net>
Date: Tue, 18 Sep 2012 13:20:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
References: <nsxa9wojdcd.fsf@closure.thunk.org>
	<20120918064039.GS11511@dastard> <50588898.6050802@sgi.com>
	<20120918181556.GC28689@thunk.org>
In-Reply-To: <20120918181556.GC28689@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 9/18/12 1:15 PM, Theodore Ts'o wrote:
> On Tue, Sep 18, 2012 at 09:43:36AM -0500, Mark Tinguely wrote:
>> xfstest 285 and 286 (I believe these tests were only in the OSS
>> version and not in the kernel.org developers version of xfstests).
> 
> Hi Mark,
> 
> Could you clarify what the relationship is between the OSS xfstests
> tree and the one on kernel.org?  Is the OSS tree always ahead of the
> kernel.org tree (i.e., are the commits in the OSS tree a superset of
> the ones in the kernel.org tree)?
> 
> I had been under the impression that commits flowed from the
> kernel.org tree to the OSS tree, but it sounds like I was misinformed
> on that point?

That was more or less correct at one point, but we recently decided to
ditch the kernel.org repos and let sgi manage a single repo on oss.sgi.com
going forward, just to simplify things.

We just reached that agreement and haven't really communicated it yet
I guess.

So going forward, stick with the one on oss.sgi.com.

Thanks,
-Eric

> Thanks,
> 
> 						- Ted
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
