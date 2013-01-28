Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 31D687F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 02:03:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1092B8F8050
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 00:03:09 -0800 (PST)
Received: from mho-02-ewr.mailhop.org (mho-04-ewr.mailhop.org [204.13.248.74])
	by cuda.sgi.com with ESMTP id JRb9OfcTvAGPuYT4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 00:03:05 -0800 (PST)
Date: Mon, 28 Jan 2013 09:03:00 +0100
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Subject: Re: Volume fine on x86_64, corruption on ARM
Message-ID: <20130128080300.GB2287@vicerveza.homeunix.net>
References: <20130127225258.GA2287@vicerveza.homeunix.net>
	<97703AFC-91DF-4839-BE07-1BE8B8A4AF91@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <97703AFC-91DF-4839-BE07-1BE8B8A4AF91@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Jan 27, 2013 at 07:52:45PM -0600, Eric Sandeen wrote:
> On Jan 27, 2013, at 4:52 PM, Llu=EDs Batlle i Rossell <viric@viric.name> =
wrote:
> =

> > Hello,
> > =

> > I'm using linux 3.7.3 in both machines (x86_64 and armv5tel), and I cre=
ated
> > a volume in x86_64 to be the rootfs for the ARM. All fine, until I plug=
ged it
> > into the ARM (Log below).
> > =

> =

> Is it stock 3.7.3 on arm, or are there any patches affecting xfs?  There =
were
> dodgy arm/xfs patches floating around a few years ago, just want to be su=
re
> they are not in use in your case...

Stock 3.7.3. The sheevaplug computer is supported in stock kernel, so I don=
't
use any patch.

Regards,
Llu=EDs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
