Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GLf6H6063460 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 16:41:06 -0500
Subject: Re: [PATCH]: [xfstests] Change test 202 to create a filesystem
	with small enough filesystem for a single AG
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1307981905.7661.461.camel@chandra-lucid.beaverton.ibm.com>
References: <1307981905.7661.461.camel@chandra-lucid.beaverton.ibm.com>
Date: Thu, 16 Jun 2011 16:41:02 -0500
Message-ID: <1308260462.2717.33.camel@doink>
MIME-Version: 1.0
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
To: sekharan@us.ibm.com
Cc: Eric Sandeen <sandeen@redhat.com>, XFS Mailing List <xfs@oss.sgi.com>

On Mon, 2011-06-13 at 09:18 -0700, Chandra Seetharaman wrote:
> Test 202 fails when the filesystem size is greater than 1TB with
> not so clear message. 
> 
> Call mkfs with a small enough filesystem size even with older 
> versions of XFS.
> 
> Signed-Off-By: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.  I will commit this for you.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
