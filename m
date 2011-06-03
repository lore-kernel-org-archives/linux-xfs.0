Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53E8J4S015578 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 09:08:19 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AD061661844
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 07:08:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RnHuLdrsPCOlURTF for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2011 07:08:18 -0700 (PDT)
Message-ID: <4DE8EAD0.8010600@redhat.com>
Date: Fri, 03 Jun 2011 10:08:16 -0400
From: Josef Bacik <josef@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix hardcoded path in output of 254
References: <1307109162-21811-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1307109162-21811-1-git-send-email-dsterba@suse.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 06/03/2011 09:52 AM, David Sterba wrote:
> Add filters after btrfs commands, else the test would incorrectly appear
> failed.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Argh thank you for that,

Reviewed-by: Josef Bacik <josef@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
