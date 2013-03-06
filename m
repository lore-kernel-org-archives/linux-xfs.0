Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AEA567F76
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 12:31:38 -0600 (CST)
Message-ID: <51378B7F.9090103@sgi.com>
Date: Wed, 6 Mar 2013 12:31:27 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: enhance ltp/fsx with a timeout option
References: <1358944851-14336-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1358944851-14336-1-git-send-email-dsterba@suse.cz>
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
Cc: xfs@oss.sgi.com

David,

Thanks for submitting this patch. I like the addition of the -T option.

I used test 263 to verify that fsx works as expected with the new -T and 
the existing -N options.  With the -T option of course, test 263 will 
fail.  I don't suggest that we change existing tests but add new tests 
which use the new -T option. Do you have a new test which you intend to 
use the -T option that can be submitted with this patch?

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
