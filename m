Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A7A3D7F76
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 15:33:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 415C8AC003
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 13:33:06 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id xpKXnoSXBoZRMpG2 (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 13:33:06 -0700 (PDT)
Subject: Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.725971.B.138186907824459@bugs.debian.org>
Date: Tue, 15 Oct 2013 12:42:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20131015194211.GA32095@infradead.org>
References: <20131010133811.GK32337@riva.ucam.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010133811.GK32337@riva.ucam.org>
Reply-To: Christoph Hellwig <hch@infradead.org>, 725971@bugs.debian.org
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
To: Colin Watson <cjwatson@ubuntu.com>, 725971@bugs.debian.org
Cc: submit@bugs.debian.org

While updating it in the debhelp is nice for the Debian package I'd also
really like to see a patch updating the files in the repository.  Colin,
would you mind sending that patch, too?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
