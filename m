Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 22CDD7FB6
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:52:19 -0500 (CDT)
Message-ID: <513F2501.4010505@sgi.com>
Date: Tue, 12 Mar 2013 07:52:17 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: determine path of logger
References: <1363045012-21119-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1363045012-21119-1-git-send-email-dsterba@suse.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: dchinner@redhat.com, xfs@oss.sgi.com

This patch has been committed.

Regards
--Rich

commit 9958693bdb282adc422bcf85f5360e3a5785e8e9
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Mar 11 23:36:52 2013 +0000

     xfstests: determine path of logger

     The path of the syslog writer utility 'logger' is hardcoded and not
     always correct, use set_prog_path.

     Signed-off-by: David Sterba <dsterba@suse.cz>
     Reviewed-by: Dave Chinner <dchinner@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
