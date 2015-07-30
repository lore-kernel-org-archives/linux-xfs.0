Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F39D7F8C
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 00:03:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE249AC00B
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 22:03:25 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id 5xLX5DSlfYT9Ov9d (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 22:03:15 -0700 (PDT)
Subject: Bug#793495: CVE-2012-2150 xfsprogs: xfs_metadump information
	disclosure
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.793495.B793495.143823235927834@bugs.debian.org>
Date: Thu, 30 Jul 2015 06:59:10 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
Message-ID: <20150730045910.GA16401@elende.valinor.li>
References: <20150724154157.15119.52609.reportbug@pisco.westfalen.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150724154157.15119.52609.reportbug@pisco.westfalen.local>
Reply-To: Salvatore Bonaccorso <carnil@debian.org>, 793495@bugs.debian.org
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
To: 793495@bugs.debian.org

Control: tags -1 + upstream fixed-upstream

Hi,

On Fri, Jul 24, 2015 at 05:41:57PM +0200, Moritz Muehlenhoff wrote:
> Package: xfsprogs
> Version: 3.2.3
> Severity: important
> Tags: security
> 
> Please see http://seclists.org/oss-sec/2015/q3/181
> for details.

A new upstream version addressing CVE-2012-2150 has been released:
http://oss.sgi.com/pipermail/xfs/2015-July/042726.html

Regards,
Salvatore

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
