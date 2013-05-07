Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 12EC229E03
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 14:59:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0459E304064
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 12:59:58 -0700 (PDT)
Date: Tue, 7 May 2013 15:59:54 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
Message-ID: <20130507195954.GA8384@redhat.com>
References: <20130507133707.GA18301@redhat.com> <51895025.2010709@sgi.com>
	<20130507190731.GA15528@redhat.com> <518954DE.4070803@sgi.com>
	<20130507193146.GA7539@redhat.com> <51895CD7.7040806@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51895CD7.7040806@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Tue, May 07, 2013 at 02:58:15PM -0500, Mark Tinguely wrote:

 > > I can hit this almost instantly with fsx. I'll do a bisect, though
 > > it sounds like you already have a suspect.
 > >
 > 
 > If you want to try kmem debug of Linux 3.8 that would help.

I'm not sure what that is.

	Dave
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
