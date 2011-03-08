Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p28K7KvU256903 for <xfs@oss.sgi.com>; Tue, 8 Mar 2011 14:07:20 -0600
Subject: Re: [PATCH] xfstests 225: Run with different random seeds
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4D764DC4.4030506@redhat.com>
References: <4D764DC4.4030506@redhat.com>
Date: Tue, 08 Mar 2011 14:10:08 -0600
Message-ID: <1299615008.2716.44.camel@doink>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, 2011-03-08 at 09:39 -0600, Eric Sandeen wrote:
> Running the fiemap-tester with a unique random seed each time
> may uncover some things missed by always using the default.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
