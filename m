Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B57827F56
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 08:10:48 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7DB888F8064
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 06:10:45 -0700 (PDT)
Message-ID: <51FBAFD5.6050307@sgi.com>
Date: Fri, 02 Aug 2013 08:10:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/49] libxfs: fix directory/attribute format issues
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 07/19/13 01:44, Dave Chinner wrote:
 > From: Dave Chinner<dchinner@redhat.com>
 >
 > directory data headers and attr leaf headers need padding for 32 bit
 > systems to correctly align the data sections on 64 bit boundaries.
 >
 > Signed-off-by: Dave Chinner<dchinner@redhat.com>
 > ---

kernel commit 5170711d

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
