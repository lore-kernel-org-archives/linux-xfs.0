Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B40027F50
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 17:38:18 -0500 (CDT)
Message-ID: <5261B854.1090701@sgi.com>
Date: Fri, 18 Oct 2013 17:38:12 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/32] xfs: dirent dtype presence is dependent on directory
	magic numbers
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>	<1380510944-8571-8-git-send-email-david@fromorbit.com>
	<525495A3.30607@sandeen.net>
In-Reply-To: <525495A3.30607@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

commit 41315687d9db9b50876401e7b0ee20dd77cfc712
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 03:15:19 2013 +0000

     xfs: dirent dtype presence is dependent on directory magic numbers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
