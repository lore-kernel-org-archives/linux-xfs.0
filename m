Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A35D7F3F
	for <xfs@oss.sgi.com>; Fri,  7 Nov 2014 16:59:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB5748F8037
	for <xfs@oss.sgi.com>; Fri,  7 Nov 2014 14:59:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fLP3brJv2JWaiaIc for <xfs@oss.sgi.com>;
	Fri, 07 Nov 2014 14:59:52 -0800 (PST)
Message-ID: <545D4EE5.6040901@sandeen.net>
Date: Fri, 07 Nov 2014 16:59:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: beginners project: RENAME_WHITEOUT
References: <20141107190959.GB21021@infradead.org>
In-Reply-To: <20141107190959.GB21021@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
Cc: Carlos Maiolino <cem@maiolino.org>, Miklos Szeredi <miklos@szeredi.hu>

On 11/7/14 1:09 PM, Christoph Hellwig wrote:
> The overlayfs merge introduces a new rename flag to create to whiteouts.
> Should be a fairly easy to implement.
> 
> Miklos, do you have any good documentation and/or test cases for this?

FWIW, Carlos just expressed some interest today in doing this, and it
builds on his earlier patches, yes?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
