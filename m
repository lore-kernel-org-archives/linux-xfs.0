Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F187A7F51
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 10:53:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC10F8F8033
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 08:53:41 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id O3K7nKPnPIOblupA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Feb 2014 08:53:40 -0800 (PST)
Date: Fri, 14 Feb 2014 17:53:38 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: test for atime-related mount options
Message-ID: <20140214165338.GX16073@twin.jikos.cz>
References: <1392305016-7424-1-git-send-email-koen.de.wit@oracle.com>
	<52FCF60F.6030703@sandeen.net>
	<20140214163925.GW16073@twin.jikos.cz>
	<52FE472C.8070503@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FE472C.8070503@sandeen.net>
Reply-To: dsterba@suse.cz
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Koen De Wit <koen.de.wit@oracle.com>, dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Feb 14, 2014 at 10:41:16AM -0600, Eric Sandeen wrote:
> I don't know that it's been discussed - selfishly, I know our QE uses
> xfstests on RHEL5, which is 2.6.18-based.

Ok then.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
