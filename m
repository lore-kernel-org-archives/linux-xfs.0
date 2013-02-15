Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF5748050
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 12:18:11 -0600 (CST)
Date: Fri, 15 Feb 2013 12:18:07 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [btrfs-progs] Btrfs quotas testing
Message-ID: <20130215181807.GN22182@sgi.com>
References: <1360932324-2722-1-git-send-email-hemanthkumar51@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360932324-2722-1-git-send-email-hemanthkumar51@gmail.com>
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
To: Hemanth Kumar <hemanthkumar51@gmail.com>
Cc: chethan.casey@gmail.com, sandeen@redhat.com, sensille@gmx.net, ganeshkumar14@gmail.com, praneethu.u@gmail.com, xfs@oss.sgi.com, hugo@carfax.org.uk, bo.li.liu@oracle.com, skjmca51@gmail.com, kirantpatil@gmail.com, linux-btrfs@vger.kernel.org

Hey Hemanth,

On Fri, Feb 15, 2013 at 06:15:24PM +0530, Hemanth Kumar wrote:
> 
> Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>

Looks like this is btrfs specific.  You probably don't need to cross post to
xfs@oss.sgi.com, unless you're interested in adding a test to xfstests.  If so,
you might want to check out the existing quota group of tests to see if one
could be modified to your purpose.

~/xfstests$ grep quota group
...

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
