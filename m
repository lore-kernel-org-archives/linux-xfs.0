Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n17DeHCw103055 for <xfs@oss.sgi.com>; Sat, 7 Feb 2009 07:40:18 -0600
Message-ID: <498D8F18.3080903@thebarn.com>
Date: Sat, 07 Feb 2009 07:39:36 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: IMPORTANT: XFS Documentation
References: <1231946704.3929.36.camel@localhost.localdomain>	<20090120160346.GJ17616@sgi.com>	<1232480744.23291.101.camel@localhost.localdomain>	<20090128202715.GR16689@sgi.com>	<1233175168.25011.155.camel@localhost.localdomain>	<20090204183603.GA26714@sgi.com>
	<4989F4C2.3030305@sgi.com> <20090205112906.GB11781@infradead.org>
In-Reply-To: <20090205112906.GB11781@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, SGI Engineering Interfaces to Red Hat <redhat-interface@sgi.com>, Marizol Martinez <martinez@redhat.com>, Tony Ernst <tee@sgi.com>, George Beshers <gbeshers@sgi.com>, John Hesterberg <jh@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>, Gary Hagensen <gwh@sgi.com>, Ric Wheeler <rwheeler@redhat.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Christoph Hellwig wrote:
>> Sorry for the delay - the lawyers were pondering the GNU FDL Vrs the
>> Creative Commons license (and settled on the latter). So now that's 
>> resolved,
>> I've updated the copyrights in the doc sources and put them in a git tree:
>>
>>     git://oss.sgi.com/xfs/cmds/xfsdocs.git
>
> Russell, can you add this to the list of repositories to be displayed on
>
>     http://oss.sgi.com/cgi-bin/gitweb.cgi
or maybe we should just update the existing xfs-website tree?
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=cattelan/xfs-website/.git;a=summary
>
> ?
>
> Talking about that any chance you could convert your cvsimport
> repositories to bare repos like all the others on oss?  And maybe
> move the old xfs-cmds import under cattelan/ like the other cvsimport
> ones?
>
I moved cvsimported xfs-import dmapi-import and xfs-cmds under archive.

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJjY8YNRmM+OaGhBgRAk6+AJsGq0ADiAlx72Cty2k6oyGBjdhxLgCfdXEc
CJwYfoMTGJxycuLpCvACU4c=
=81ro
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
