Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EIM0ds152849 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 13:22:01 -0500
Subject: Re: [PATCH 1/2 v7] XFS TESTS: ENOSPC Punch Hole: Move su routines
	in 123 to common.rc
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1309272301-5742-2-git-send-email-achender@linux.vnet.ibm.com>
References: <1309272301-5742-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309272301-5742-2-git-send-email-achender@linux.vnet.ibm.com>
Date: Thu, 14 Jul 2011 13:21:55 -0500
Message-ID: <1310667715.2067.42.camel@doink>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, 2011-06-28 at 07:45 -0700, Allison Henderson wrote:
> This patch moves the su routines in test 123 to common.rc
> so that they can also be used in the new test 255
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>

This looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
