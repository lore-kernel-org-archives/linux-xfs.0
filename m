Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5B94B7F51
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 13:09:33 -0600 (CST)
Date: Fri, 1 Feb 2013 13:09:30 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using git
	archive
Message-ID: <20130201190930.GX27055@sgi.com>
References: <50F44B2E.9050408@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50F44B2E.9050408@sgi.com>
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
To: Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 14, 2013 at 12:15:10PM -0600, Andrew Dahl wrote:
> The following four patches fix an issue seen during the last user space
> release where not all source files were included in xfsprogs.  They each
> change xfsprogs, xfstests, xfsdump, and dmapi to all use git archive for
> source tarball generation and add 'make realclean' in the release
> scripts to ensure the configure and m4/autotools temp files are refreshed.

Applied this series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
