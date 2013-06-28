Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B3907F93
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 17:53:05 -0500 (CDT)
Date: Fri, 28 Jun 2013 17:53:01 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v10 00/11] Allow pquota and gquota to be used together
Message-ID: <20130628225301.GF20932@sgi.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 27, 2013 at 05:25:03PM -0500, Chandra Seetharaman wrote:
> Hello All,
> 
> This is the version 10 of the changes to allow pquota and gquota to be used
> together.
> 
> Patchset applies cleanly on top of 80a4049813a2ae0977d8e5db78e711c7f21c420b
> in xfs git tree.
> 
> Ran xfstests against it with DEBUG and do not see any regressions.

Applied patches 1-4,6,7.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
