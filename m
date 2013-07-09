Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 95A3D7F37
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 11:11:23 -0500 (CDT)
Date: Tue, 9 Jul 2013 11:11:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfstests: fix README, FSTYP options
Message-ID: <20130709161119.GP20932@sgi.com>
References: <20130625153423.513e4074@oracle.com>
	<20130626005029.GY29376@dastard>
	<20130627115736.66d28ca1@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130627115736.66d28ca1@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 27, 2013 at 11:57:36AM -0400, Dwight Engen wrote:
> commit cbcc88fb changed test selection to use shell globs, so fixup the
> examples given in the README file.
> 
> remove options for FSTYP other than NFS since the FSTYP will be automatically
> detected (on Linux) from $TEST_DEV.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

Looks good.  Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
