Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2ULbJwV083708 for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 16:37:20 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E02BB1DFCEE1
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 14:40:29 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.166.49.3]) by
	cuda.sgi.com with SMTP id Y1tki8lmUo6GuWZh for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2011 14:40:29 -0700 (PDT)
Date: Thu, 31 Mar 2011 08:40:26 +1100 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <962663761.15158.1301521226508.JavaMail.root@acxmail-au2.aconex.com>
In-Reply-To: <1301513820.2953.23.camel@doink>
Subject: Re: [PATCH v2] xfsprogs: update CHANGES file for release
MIME-Version: 1.0
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com


----- Original Message -----
> Update the CHANGES file, in preparation for releasing xfsprogs
> 3.1.5. Updated to modify debian/changelog, and to give appropriate
> credit to contributors.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
> debian/changelog | 4 ++++
> doc/CHANGES | 15 +++++++++++++++
> 2 files changed, 19 insertions(+)
> 
> Index: b/debian/changelog
> ===================================================================
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,3 +1,7 @@
> +xfsprogs (3.1.5) unstable; urgency=low
> + * New upstream release
> + * No more xfsquota error message for non-quota mounts (closes:
> #618730)
> +
> xfsprogs (3.1.4) unstable; urgency=low

Are we missing the timestamp line there?  (previous version had it, I think)
Otherwise looks good, thanks!

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
